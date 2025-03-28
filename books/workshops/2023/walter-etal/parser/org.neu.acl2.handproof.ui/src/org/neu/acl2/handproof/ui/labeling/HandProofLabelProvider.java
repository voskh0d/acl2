/*
 * generated by Xtext 2.20.0
 */
package org.neu.acl2.handproof.ui.labeling;

import java.util.List;
import java.util.stream.Collectors;

import org.eclipse.emf.edit.ui.provider.AdapterFactoryLabelProvider;
import org.eclipse.xtext.ui.label.DefaultEObjectLabelProvider;
import org.neu.acl2.handproof.handProof.BackquotedSExpressionExpr;
import org.neu.acl2.handproof.handProof.CommaSExpression;
import org.neu.acl2.handproof.handProof.Const;
import org.neu.acl2.handproof.handProof.Context;
import org.neu.acl2.handproof.handProof.ContractCompletionSection;
import org.neu.acl2.handproof.handProof.DefineC;
import org.neu.acl2.handproof.handProof.DefineCSExp;
import org.neu.acl2.handproof.handProof.DefunC;
import org.neu.acl2.handproof.handProof.DefunCSExp;
import org.neu.acl2.handproof.handProof.DerivedContext;
import org.neu.acl2.handproof.handProof.ExportationSection;
import org.neu.acl2.handproof.handProof.Goal;
import org.neu.acl2.handproof.handProof.HintList;
import org.neu.acl2.handproof.handProof.OptionallyDottedSExpList;
import org.neu.acl2.handproof.handProof.OptionallyDottedSExpListExpr;
import org.neu.acl2.handproof.handProof.Proof;
import org.neu.acl2.handproof.handProof.ProofBody;
import org.neu.acl2.handproof.handProof.ProofName;
import org.neu.acl2.handproof.handProof.Property;
import org.neu.acl2.handproof.handProof.PropertySExp;
import org.neu.acl2.handproof.handProof.QuotedSExpressionExpr;
import org.neu.acl2.handproof.handProof.SExpList;
import org.neu.acl2.handproof.handProof.SExpression;
import org.neu.acl2.handproof.handProof.Symbol;

import com.google.inject.Inject;

/**
 * Provides labels for EObjects.
 * 
 * See https://www.eclipse.org/Xtext/documentation/310_eclipse_support.html#label-provider
 */
public class HandProofLabelProvider extends DefaultEObjectLabelProvider {

	@Inject
	public HandProofLabelProvider(AdapterFactoryLabelProvider delegate) {
		super(delegate);
	}
	
	private static <T> int indexOfIdentity(List<T> list, T o) {
		int i = 0;
		for(T item : list) {
			if(o == item) {
				return i;
			}
			i++;
		}
		return -1;
	}
	
//	String text(SExpression sexpr) {
//		if(sexpr instanceof SExpListExpr) {
//			return text(((SExpListExpr) sexpr).getList());
//		}
//		if(sexpr instanceof Symbol) {
//			return ((Symbol) sexpr).getValue();
//		}
//		if(sexpr instanceof Const) {
//			return ((Const) sexpr).getValue();
//		}
//		if(sexpr instanceof QuotedSExpression) {
//			return "'" + text(((QuotedSExpression) sexpr).getSexp());
//		}
//		throw new RuntimeException(sexpr.toString());
//	}
	
	
	String text(Goal goal) {
		return "Goal";
	}
	
	String text(Context ctx) {
		return "Context";
	}
	
	String text(DerivedContext ctx) {
		return "Derived Context";
	}
	
	String text(ProofBody body) {
		return "Proof";
	}
	
	String text(ExportationSection es) {
		return "Exportation";
	}
	
	String text(ContractCompletionSection ccs) {
		return "Contract Completion";
	}
	
	String text(Symbol symbol) {
		return symbol.getValue();
	}
	
	String text(Const c) {
		return c.getValue();
	}
	
	String text(SExpList list) {
		return "(" + list.getBody().stream().map(item -> getText(item)).collect(Collectors.joining(" ")) + ")";
	}
	
	String text(OptionallyDottedSExpListExpr expr) {
		return getText(expr.getList());
	}
	
	String text(QuotedSExpressionExpr expr) {
		return "'" + getText(expr.getSexp());
	}
	
	String text(BackquotedSExpressionExpr expr) {
		return "`" + getText(expr.getSexp());
	}
	
	String text(DefineCSExp def) {
		return getText(def.getValue());
	}
	
	String text(DefunCSExp def) {
		return getText(def.getValue());
	}
	
	String text(CommaSExpression expr) {
		StringBuilder b = new StringBuilder(",");
		if(expr.getSplice() != null && expr.getSplice().equals("@")) {
			b.append("@");
		}
		b.append(getText(expr.getSexp()));
		return b.toString();
	}
	
	String text(DefineC def) {
		return "definec " + def.getName();
	}
	
	String text(DefunC def) {
		return "defunc " + def.getName();
	}
	
	String text(Property prop) {
		if(prop.getName() != null) {
			return "property " + prop.getName() + " ...";
		}
		return "property ..."; 
	}
	
	String text(PropertySExp expr) {
		return getText(expr.getValue());
	}
	
	String text(OptionallyDottedSExpList list) {
		StringBuilder b = new StringBuilder("(");
		b.append(list.getBody().stream().map(item -> getText(item)).collect(Collectors.joining(" ")));
		if(list.getRight() != null) {
			b.append(". ");
			b.append(getText(list.getRight()));
		}
		b.append(")");
		return b.toString();
	}
	
	// This is a hack to make the outline view nicer.
	// Basically we use the HintList to identify the "before" statement and the "next" statement.
	// We then display the relation being expressed.
	String text(HintList hl) {
		if(hl.eContainer() instanceof ProofBody) {
			ProofBody pb = (ProofBody)hl.eContainer();
			int idx = indexOfIdentity(pb.getHints(), hl);
			if(idx == -1) {
				throw new RuntimeException("Failed to find index for hintlist!");
			}
			if(idx == 0) {
				StringBuilder sb = new StringBuilder();
				sb.append(getText(pb.getFirstStatement()));
				sb.append(" " + pb.getRels().get(0) + " ");
				sb.append(getText(pb.getRestStatements().get(0)));
				return sb.toString();
			} else {
				StringBuilder sb = new StringBuilder();
				sb.append(getText(pb.getRestStatements().get(idx-1)));
				sb.append(" " + pb.getRels().get(idx) + " ");
				sb.append(getText(pb.getRestStatements().get(idx)));
				return sb.toString();
			}
		} else {
			return "";
		}
	}
	
	String text(ProofName name) {
		return name.getKind() + " " + name.getName();
	}
	
	String text(Proof proof) {
		return getText(proof.getHeader().getName());
	}
}
